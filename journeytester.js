var System;

System = require('system');

var config;

config = {
  website: System.args[1],
  timeout: 3000,
  testName: 'simo',
  viewportSizes: [
    {
      width: 420,
      height: 1080
    }
  ],
  testflow: [
    {
      name: 'tableloaded'
    }, {
      name: 'splashpageloaded',
      click: '.btn__table--see-deal',
      timeout: 3000
    }
  ]
};

var JourneyTester;

JourneyTester = (function() {
  var Page, loadingRequests, runTest, setupTest, testFlowCount, timestamp;

  Page = require('webpage').create();

  loadingRequests = 0;

  testFlowCount = 0;

  timestamp = new Date().getTime();

  function JourneyTester(config) {
    this.config = config;
    setupTest(this.config.website);
  }

  Page.onResourceReceived = function(response) {
    loadingRequests += 1;
    return setTimeout(function() {
      loadingRequests -= 1;
      if (loadingRequests === 0) {
        return runTest();
      }
    }, this.config.timeout);
  };

  setupTest = function(website) {
    console.log('setting up test');
    Page.viewportSize = this.config.viewportSizes[0];
    return Page.open(website, function(status) {
      if (status !== 'success') {
        console.log('there was an error setting the test up: ' + status);
        return phantom.exit();
      }
    });
  };

  runTest = function() {
    var currentTest;
    testFlowCount += 1;
    console.log("running testFlow " + testFlowCount);
    currentTest = this.config.testflow.shift();
    if (currentTest.click) {
      Page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', function() {
        var clickable;
        return clickable = Page.evaluate(function(element) {
          return $($(element)[0]).click();
        }, currentTest.click);
      });
    }
    return setTimeout(function() {
      console.log("finishing testFlow " + testFlowCount);
      Page.render("tests/" + this.config.testName + timestamp + "/" + currentTest.name + ".png");
      if (this.config.testflow.length === 0) {
        console.log('test finished, check report.json');
        return phantom.exit();
      } else {
        return runTest();
      }
    }, currentTest.timeout || 20);
  };

  return JourneyTester;

})();

var testing;

if (System.args.length === 1) {
  console.log("\n\nERROR: no arguments received \nexample: phantomjs journeytester.js 'http://website.com'\n\n ");
  phantom.exit();
}

testing = new JourneyTester(config);
