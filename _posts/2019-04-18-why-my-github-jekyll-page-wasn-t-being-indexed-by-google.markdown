---
layout: single
title: "Why my github (Jekyll) page wasn't being indexed by Google"
date: "2019-04-18 15:11:44 -0700"
tags: meta jekyll webmasters indexing mimimal-mistakes
---
## The Problem
I added this site to Google Webmasters a week ago. In their **URL Inspection tool**, it said *"Crawled - currently not indexed"*, and that the page was "excluded". As a result, the site wasn't being listed on Google.

## The Solution
I noticed that the **user-defined canonical url** shown on Webmasters was https://techknowfile.dev/techknowfile.dev. I opened my Jekyll _config.yml file and changed `url: "techknowfile.dev"` to `url: "https://techknowfile.dev"`. Saved. Pushed. 10 seconds later, the Webmaster's URL Inspection page changed to "URL is on Google". Problem solved.
