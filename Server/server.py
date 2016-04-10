from flask import Flask
from flask_restful import Resource, Api

from comic import Comic
import search

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
    return {'url': url}

class SearchResource(Resource):
  def __init__(self, index):
    self.index = index

  def get(self, query):
    return [{'date': date.format('YYYY-MM-DD'), 'text': search.select_text(text, query)}
            for date, text in self.index.query(query)]

if __name__ == '__main__':
  print('creating index')
  index = search.create_index('Server/calvin_transcript.txt', 8)
  print('finished creating index, now registering api resources')
  api.add_resource(ComicResource,
                   '/comic/<string:date>')  # date format: YYYY-MM-DD
  api.add_resource(SearchResource,
                   '/search/<string:query>',
                   resource_class_args=(index,))
  print('starting server')
  app.run()
