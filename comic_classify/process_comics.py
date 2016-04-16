from sklearn import svm, cluster
from PIL import Image
import numpy as np
from datetime import timedelta, date
import requests as r
import json
from io import BytesIO
import os

MAX_IMAGE_HEIGHT = 260

def load_data(path):
	img = Image.open(path).convert('1')
	return np.array([0 if pxl == 0 else 1 for pxl in img.getdata()]).reshape(img.size)

def get_frame(data, i=0):
	return data[i:i+25, :MAX_IMAGE_HEIGHT].ravel()

def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

def load_data_from_date(date):
	date_str = date.strftime('%Y-%m-%d')
	url = 'https://calvinserver.herokuapp.com/comic/{}'.format(date_str)
	data = json.loads(r.get(url).text)
	img_url = data['url']
	img_bytes = BytesIO(r.get(img_url).content)
	return load_data(img_bytes)

def load_images(path):
	images = []
	for img_file in os.listdir(path):
		if img_file.startswith('.'):
			continue
		data = load_data(path + '/' + img_file)
		images.append(data)
	return images

def get_panels(date, clf):
	img = load_data_from_date(date)
	print(img)
	w, h = img.shape
	frames = [get_frame(img, i) for i in range(w - 25)]
	for frame in frames:
		if clf.predict([frame])[0] == 0.0:
			print('asdfasdfadsfa')
	# print(matches)

def train(edges, nonedges):
	edges = np.vstack([get_frame(img).ravel() for img in load_images(edges)])
	nonedges = np.vstack([get_frame(img).ravel() for img in load_images(nonedges)])
	X = np.concatenate((edges, nonedges))
	y = np.concatenate((np.ones((edges.shape[0],)),
						np.zeros((nonedges.shape[0],))))
	clf = svm.SVC(gamma=.001, C=100.)
	clf.fit(X, y)
	print(clf.score(X, y))
	return clf

if __name__ == '__main__':
	clf = train('edges', 'nonedges')
	panels_for_date = {}
	start = date(1985, 11, 18)
	end = date(1985, 11, 21)
	for date in daterange(start, end):
		panels = get_panels(date, clf)
		print(panels)
		panels_for_date[date] = panels
	