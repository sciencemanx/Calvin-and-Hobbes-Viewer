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
	words_combinations = list(chain.from_iterable(ngrams(query, n) 
														for n in range(1, len(cleaned_words) + 1)))
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
	def __init__(self, accuracy=8):
		self.index = defaultdict(list)
		self.texts = {}
		self.text_lengths = {}
		self.accuracy = accuracy

	def __setitem__(self, date, text):
		self.add(date, text)

	def __getitem__(self, text):
		return self.query(text)

	def add(self, date, text):
		self.texts[date] = text
		self.text_lengths[date] = len(separate_words(text))
		for n in range(1, self.accuracy):
			for ngram in ngrams(text, n):
				dates = self.index[ngram]
				dates.append(date)

	def query(self, text, count=10):
		bigrams = ngrams(text)
		results = Counter()
		for n in range(1, self.accuracy):
			for ngram in ngrams(text, n):
				results.update(self.index[ngram] * (n ** 2))
		return [(date, self.texts[date])
				for date, count in results.most_common(count)]

def create_index(filename, accuracy=8):
	with open(filename, 'r') as f:
		text = f.read()

	comics_sep = re.compile(r'(ch[\d]{6})(?:: )(.*?)(?= ch[0-9]{6})')
	comics = comics_sep.findall(text)
	index = invertedindex(accuracy)
	for comic, text in comics:
		date = arrow.get(comic, 'YYMMDD')
		index[date] = text
	return index
