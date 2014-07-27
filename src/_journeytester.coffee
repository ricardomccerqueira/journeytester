class JourneyTester
  Page              = require('webpage').create()
  loadingRequests   = 0
  testFlowCount     = 0
  timestamp         = new Date().getTime()
  
  constructor: (@config) ->
    setupTest @config.website

  # onResourceReceived maybe called more often than onResourceRequested, because if data is too big, it comes in chunks:
  # http://phantomjs.org/api/webpage/handler/on-resource-received.html for this reason.. i need to do some workaround hacking stuff
  Page.onResourceReceived = (response)->
    loadingRequests += 1
    setTimeout ->
      loadingRequests -= 1
      if loadingRequests == 0
        runTest()
    ,@config.timeout
    
  setupTest = (website)->
    console.log 'setting up test'
    Page.viewportSize = @config.viewportSizes[0]

    Page.open website, (status)->
      unless status == 'success'
        console.log 'there was an error setting the test up: ' + status
        phantom.exit()
  
  runTest = ()->
    testFlowCount += 1
    console.log "running testFlow #{testFlowCount}"
    currentTest = @config.testflow.shift()

    if currentTest.click
      Page.includeJs 'http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', ()->
        clickable = Page.evaluate((element) ->
          $($(element)[0]).click()
        , currentTest.click)

    setTimeout ->
      console.log "finishing testFlow #{testFlowCount}"
      Page.render("tests/#{@config.testName}#{timestamp}/#{currentTest.name}.png")
      if @config.testflow.length == 0
        console.log 'test finished, check report.json'
        phantom.exit()
      else
        runTest()
    ,currentTest.timeout || 20