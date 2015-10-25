from flask import Flask
from flask_restful import Resource, Api

from Server.comic import Comic

app = Flask(__name__)
api = Api(app)

comics = dict()


class ComicResource(Resource):
    def get(self, date):
        if date not in comics:
            comic = Comic(date)
            comics[comic.date_str()] = comic
        url = comics[date].url()
        return {"url": url}

api.add_resource(ComicResource,
                 "/comic/<string:date>")  # date format: YYYY-MM-DD

if __name__ == "__main__":
    app.run(debug=True)
