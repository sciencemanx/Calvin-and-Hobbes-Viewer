#!/usr/bin/env python3

from flask import Flask
from flask_restful import Resource, Api

if __name__ == '__main__': # run as python Server/server.py
  from comic import Comic
  import search
else: # run as heroku local
  from .comic import Comic
  from . import search


app = Flask(__name__)
api = Api(app)

class ComicResource(Resource):
  def __init__(self):
    self.comics = {}

  def get(self, date):
    if date not in self.comics:
      comic = Comic(date)
      self.comics[comic.date_str()] = comic
    url = self.comics[date].url()
    return {'url': url, 'seps': '224 457 666'}

class SearchResource(Resource):
  def __init__(self, index):
    self.index = index

  def get(self, query):
    return [{'date': date.format('YYYY-MM-DD'), 'text': search.select_text(text, query)}
            for date, text in self.index.query(query)]

def setup():
  print('creating index')
  index = search.create_index('Server/calvin_transcript.txt', 5)
  print('finished creating index, now registering api resources')
  api.add_resource(ComicResource,
                   '/comic/<string:date>')  # date format: YYYY-MM-DD
  api.add_resource(SearchResource,
                   '/search/<string:query>',
                   resource_class_args=(index,))

if __name__ == '__main__':
  setup()
  print('starting server')
  app.run(debug=True)
