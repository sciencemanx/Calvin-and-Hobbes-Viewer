from bs4 import BeautifulSoup as bs
import requests as r
import arrow
from datetime import timedelta


class Comic:
    def __init__(self, date_str):
        self.date = arrow.get(date_str)
        self._url = get_url(self.date_path())
        self.last_checked = arrow.now()

    def check(self):
        self._url = get_url(self.date_path())
        self.last_checked = arrow.now()

    def url(self):
        if (arrow.now() - self.last_checked) > timedelta(seconds=10):
            self.check()
        return self._url

    def date_path(self):
        return self.date.format("YYYY/MM/DD")

    def date_str(self):
        return self.date.format("YYYY-MM-DD")

    def __str__(self):
        return "Comic({}, {})".format(self.date_str(), self.url())


def format_date(date):
    return date.format("YYYY/MM/DD")


def get_url(date_path):  # date format: YYYY-MM-DD
    # gocomics rejects requests from crawler
    url = "http://www.gocomics.com/calvinandhobbes/{}".format(date_path)
    print(url)
    headers = {"User-Agent": "Mozilla/5.0"}
    response = r.get(url,
                     headers=headers)
    # unicode returned in page
    html_text = response.text.encode('utf-8')
    page = bs(html_text, 'html.parser')

    comic_url = page.find("img", {"class": "strip"})["src"]

    return comic_url


def get_comic(date_str):  # date format: YYYY-MM-DD
    return Comic(date_str)
