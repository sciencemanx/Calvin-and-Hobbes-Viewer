from comic_detect import load_images, train, search_picture
import os
import sys

def main():
	if len(sys.argv) != 4:
		print('Usage: {} <edges-dir> <non-edges-dir> <comics-dir>'.format(sys.argv[0]))
		sys.exit(-1)
	edge_dir = sys.argv[1]
	non_edge_dir = sys.argv[2]
	comics_dir = sys.argv[3]

	edges = load_images(edge_dir)
	nonedges = load_images(non_edge_dir)

	clf = train(edges, nonedges)

	comic_index = {}

	for file in os.listdir(comics_dir):
		if not file.endswith('.gif'):
			continue
		path = '{}/{}'.format(comics_dir, file)
		try:
			panels, _ = search_picture(clf, path)
		except Exception as e:
			print('{} probably had a dimension issue'.format(file))
			print(e)
		else:
			print(file, panels)
			comic_index[file] = panels

	print(comic_index)

if __name__ == '__main__':
	main()
