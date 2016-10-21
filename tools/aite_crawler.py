from lxml import etree, html
from requests.adapters import HTTPAdapter
import requests
import os
import json
import re

aite_sm = 'http://www.allitebooks.com/post-sitemap{0}.xml'

urls = []

with open('list-of-post-urls-allitbooks.md', 'w') as fp:
    for i in range(1, 8):
        fp.write('\n\n## Post Sitemap {0}\n\n'.format(i))
        req = requests.get(aite_sm.format(i))
        root = etree.fromstring(req.content)
        for sitemap in root:
            url = sitemap.getchildren()[0].text
            fp.write('[{0}]({1})\n'.format(url, url))
            urls.append(url)
        print('Done with ' + str(i))

down_dict = {}

if not os.path.exists('all-it-ebooks'):
    os.mkdir('all-it-ebooks')

save_dir = os.path.abspath(os.path.join(os.curdir, 'all-it-ebooks'))

print('Crawling in Progress ......\n')
for i, url in enumerate(urls[1:101]):
    print(i)
    page = requests.Session()
    page.mount(url, HTTPAdapter(max_retries=5))
    page = page.get(url)
    tree = html.fromstring(page.content)
    down_link = tree.xpath("//*[@class=\"download-links\"]/a/@href")
    file_name = down_link[0].split('/')[-1]
    title = re.sub('[^A-Za-z0-9]+', '-', file_name.split('.')[0])    
    down_dict[title] = down_link[0]
    
print('\nAll Urls have been crawled.')
print('\nWriting links to JSON file.\n')

with open('all-it-ebooks-download-links.json', 'w') as fp:
    json.dump(down_dict, fp, indent=4)
    print('\t----- Writing Complete')
