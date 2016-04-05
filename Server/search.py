import re
from collections import defaultdict, Counter
from flask_restful import Resource
import arrow

sep = re.compile(r'\n| ')
def separate_words(text):
	return sep.split(text)

strip = re.compile(r'\(|\)|\'|\"|\?|,|\.|!')
def preprocess(text):
	words = separate_words(text)
	basic_words = (strip.sub('', word) for word in words)
	return (word.lower() for word in basic_words)

def ngrams(corpus, n=2):
	tokens = list(preprocess(corpus))
	offsets = (tokens[offset:] for offset in range(n))
	return set(zip(*offsets))

def sublist_index(lst, sublst):
	n = len(sublst)
	lst, sublst = list(lst), list(sublst)
	matches = [sublst == lst[i:i+n] for i in range(len(lst))]
	return matches.index(True) if True in matches else -1

from itertools import chain
def select_text(text, query):
	cleaned_words = list(preprocess(query))
	cleaned_text_words = list(preprocess(text))
	words_combinations = list(chain.from_iterable(ngrams(query, n) for n in range(2, len(cleaned_words) + 1)))
	for words_combination in reversed(words_combinations):
		start_location = sublist_index(cleaned_text_words, words_combination)
		if start_location != -1:
			text_words = list(separate_words(text))
			lo = max(0, start_location - 5)
			hi = min(len(text_words) - 1, start_location + len(words_combination) + 5)
			first_words = ' '.join(text_words[lo: start_location])
			last_words = ' '.join(text_words[start_location + len(words_combination): hi])
			middle_words = ' '.join(text_words[start_location: start_location + len(words_combination)])
			return '{} _{}_ {}'.format(first_words, middle_words, last_words)


class invertedindex:
	def __init__(self):
		self.index = defaultdict(list)
		self.texts = {}

	def __setitem__(self, date, text):
		self.add(date, text)

	def __getitem__(self, text):
		return self.query(text)

	def add(self, date, text):
		self.texts[date] = text
		bigrams = ngrams(text)
		for bigram in bigrams:
			titles = self.index[bigram]
			titles.append(date)

	def query(self, text, n=10):
		bigrams = ngrams(text)
		results = Counter()
		for bigram in bigrams:
			results.update(self.index[bigram])
		return [(date, self.texts[date])
				for date, count in results.most_common(n)]

with open('Server/calvin_transcript.txt') as f:
	text = f.read()

comics_sep = re.compile(r'(ch[\d]{6})(?:: )(.*?)(?= ch[0-9]{6})')
comics = comics_sep.findall(text)
index = invertedindex()
for comic, text in comics:
	date = arrow.get(comic, 'YYMMDD')
	index[date] = text

class SearchResource(Resource):
	def get(self, query):
		return [{"date": date.format('YYYY-MM-DD'), "text": select_text(text, query)}
				for date, text in index.query(query)]