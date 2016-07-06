from sklearn import svm, cluster
from PIL import Image, ImageDraw
import os
import sys
import random



def load_images(dirname):
	images = []
	for image_name in os.listdir(dirname):
		if image_name.startswith('.'):
			continue
		image = Image.open(dirname + '/' + image_name).convert('1')
		x, y = image.size
		image = image.resize((x, 280), Image.ANTIALIAS)
		data = [0 if pixel == 0 else 1 for pixel in image.getdata()]
		images.append(data)
	return images

min_len = 10000000
def normalize(X):
	global min_len
	min_len = min(min_len, min(len(x) for x in X))
	return [x[:min_len] for x in X]

def crossvalidate(edges, nonedges):
	random.shuffle(edges)
	random.shuffle(nonedges)
	train_edge_len, train_nonedge_len = len(edges) * 7 // 10, len(nonedges) * 7 // 10
	cross_edge_len, cross_nonedge_len = len(edges) - train_edge_len, len(nonedges) - train_nonedge_len

	X_train = normalize(nonedges[:train_nonedge_len] + 
						edges[:train_edge_len])
	y_train = [0] * train_nonedge_len + [1] * train_edge_len

	X_cross = normalize(nonedges[train_nonedge_len:] + 
						edges[train_edge_len:])
	y_cross = [0] * cross_nonedge_len + [1] * cross_edge_len

	clf = svm.SVC(gamma=.001, C=100.)
	clf.fit(X_train, y_train)
	print("prediction: {}".format(list(clf.predict(X_cross))))
	print("actuallity: {}".format(y_cross))
	print(clf.score(X_cross, y_cross))

def get_column(img, i):
	w, h = img.size
	column = []
	for j in range(h):
			column.append(0 if img.getpixel((i, j)) == 0 else 1)
	return column

def search_picture(clf, image_name):
	image = Image.open(image_name).convert('1')
	x, y = image.size
	image = image.resize((x, 280), Image.ANTIALIAS)
	w, h = image.size

	columns = [get_column(image, i) for i in range(25)]
	datas = []
	for i in range(25, w):
		columns = columns[1:] + [get_column(image, i)]
		data = [columns[i][j] for j in range(len(columns[0])) for i in range(len(columns))]
		datas.append(data)
	datas = normalize(datas)
	matches = [[i] for i, m in enumerate(clf.predict(datas)) if m == 1]
	if len(matches) == 0:
		return [], matches
	clst = cluster.DBSCAN(eps=20, min_samples=1)
	clst.fit(matches)
	trimmed = [idx for idx in clst.components_ if idx > w // 6 and idx < w * 5 // 6]
	clst = cluster.KMeans(3, init='k-means++')
	clst.fit(trimmed)
	seps = list(sorted([int(v[0]) + 25//2 for v in clst.cluster_centers_]))
	final_seps = []
	for start, end in zip(seps, seps[1:]):
		if (end - start) > w // 6:
			final_seps.append(start)
	final_seps.append(seps[-1])
	return final_seps, matches

def train(edges, nonedges):
	clf = svm.SVC(gamma=.001, C=100.)
	X = normalize(nonedges + edges)
	y = [0] * len(nonedges) + [1] * len(edges)
	clf.fit(X, y)
	return clf


def main(edge_dir, non_edge_dir):
	edges = load_images(edge_dir)
	nonedges = load_images(non_edge_dir)

	crossvalidate(edges, nonedges)

	clf = train(edges, nonedges)

	for comic in os.listdir('test'):
		print(comic)
		panels, matches = search_picture(clf, 'test/' + comic)
		print("\tpanels: {}".format(panels))
		image = Image.open('test/' + comic).convert('RGBA')
		draw = ImageDraw.Draw(image)
		w, h = image.size
		for match in matches:
			match = match[0]
			draw.line((match, 0) + (match, h), fill=(0,0,255,0))
		for sep in panels:
			draw.line((sep, 0) + (sep, h), fill=(255,0,0), width=3)
		image.show()

	return clf

if __name__ == '__main__':
	if len(sys.argv) != 3:
		print('Usage: {} <edges-dir> <non-edges-dir>'.format(sys.argv[0]))
		sys.exit(1)
	edge_dir = sys.argv[1]
	non_edge_dir = sys.argv[2]
	main(edge_dir, non_edge_dir)
	