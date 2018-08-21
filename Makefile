
NOTEBOOK = https://api.observablehq.com/@jflatow/headless-observable.js?key=7d7a86c7b4aefbef

CHROME_PATH = /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary
CHROME_PORT = 9222
CHROME_OPTS = --remote-debugging-port=$(CHROME_PORT) --headless
CHROME_PAGE = file:///$(abspath notebook.html)\#$(NOTEBOOK)

run:
	$(CHROME_PATH) $(CHROME_OPTS) $(CHROME_PAGE)
