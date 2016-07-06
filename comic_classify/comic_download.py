from bs4 import BeautifulSoup as bs
import requests as r
import arrow
from datetime import timedelta, date
import re

# copied from comic.py, sue me
def get_url(date):  # date format: YYYY-MM-DD
    # gocomics rejects requests from crawler
    date_path = date.strftime("%Y/%m/%d")
    url = "http://www.gocomics.com/calvinandhobbes/{}".format(date_path)
    print(url)
    headers = {"User-Agent": "Mozilla/5.0"}
    response = r.get(url, headers=headers)
    # unicode returned in page
    html_text = response.text.encode('utf-8')
    page = bs(html_text, 'html.parser')
    container_div = page.find("div" , id=re.compile("mutable_.*"))
    image_tag = container_div.find("img")
    comic_url = image_tag["src"]

    return comic_url

def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

def download_comic(date):
	url = get_url(date)
	img = r.get(url, stream=True)
	return img

def main():
	import sys
	if len(sys.argv) != 2:
		print('Usage: {} <download-dir>'.format(sys.argv[0]))
		sys.exit(-1)

	out_dir = sys.argv[1]

	start = date(1986, 10, 6) #error with date(1986, 10, 6)
	end = date(1986, 11, 18)
	for d in daterange(start, end):
		if d.weekday() == 6: #sunday
			continue
		img = download_comic(d)
		path = '{}/{}.gif'.format(out_dir, d.strftime('%Y-%m-%d'))
		with open(path, 'wb') as f:
			for chunk in img:
				f.write(chunk)

if __name__ == '__main__':
	main()
