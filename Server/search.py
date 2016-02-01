import re
from collections import defaultdict, Counter
from flask_restful import Resource
import arrow

strip = re.compile(r'\(|\)|\'|\?|,|\.|!')
def preprocess(words):
	basic_words = (strip.sub('', word) for word in words)
	return (word.lower() for word in basic_words)

sep = re.compile(r'\n| ')
def ngrams(corpus):
	words = sep.split(corpus)
	tokens = list(preprocess(words))
	return set(zip(tokens, tokens[1:]))

class invertedindex:
	def __init__(self):
		self.index = defaultdict(list)

	def __setitem__(self, title, text):
		self.add(title, text)

	def __getitem__(self, text):
		return self.query(text)

	def add(self, title, text):
		bigrams = ngrams(text)
		for bigram in bigrams:
			titles = self.index[bigram]
			titles.append(title)

	def query(self, text, n=10):
		bigrams = ngrams(text)
		results = Counter()
		for bigram in bigrams:
			results.update(self.index[bigram])
		return [date for date, count in results.most_common(n)]

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
		return [date.format('YYYY-MM-DD') for date in index.query(query)]