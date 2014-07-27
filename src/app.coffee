if System.args.length == 1
  console.log "\n\nERROR: no arguments received \nexample: phantomjs journeytester.js 'http://website.com'\n\n "
  phantom.exit()

testing = new JourneyTester(config)
