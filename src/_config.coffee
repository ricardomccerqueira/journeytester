config =
  website: System.args[1]
  timeout: 3000
  testName: 'simo'
  viewportSizes: [
    {
      width: 420
      height: 1080
    }
  ]
  testflow: [
    {
      name: 'tableloaded'
    }
    {
      name: 'splashpageloaded'
      # make it possible to be an array:
      click: '.btn__table--see-deal'
      timeout: 3000
    }
  ]

