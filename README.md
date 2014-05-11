WebCrawler
==========

Simple web crawler and site map creator.

Usage
=====

```
  bundle
  ./bin/site_mapper -u http://mydomain.com -o sitemap.html
```

This will crawl all pages that are linked in the mydomain.com domain, and write a
simple site map in the sitemap.html file.

Limitations and Behaviours:
===========================

* It will map only linked pages from the same domain given.
* Sub-domains are not crawled.
* It will crawl http and https links, as long as they have the same domain.
* Redirects are not followed, but they will be listed in the site map.


