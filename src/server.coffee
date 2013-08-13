express = require "express"
request = require "request"
qs = require "querystring"
app = express()

# Serve the client application
app.get "/", (req, res) ->
  res.sendfile "index.html"

app.get "/favicon.ico", (req, res) ->
  res.sendfile "favicon.ico"

app.use "/scripts", express.static "#{__dirname}/scripts"
app.use "/styles", express.static "#{__dirname}/styles"
app.use "/vendor", express.static "#{__dirname}/vendor"
app.use "/img", express.static "#{__dirname}/img"
app.use "/mitigation", express.static "#{__dirname}/mitigation"

# Provide a proxy for cross-origin information
app.get "/proxy", (req, res) ->
  # Get the requested URL
  url = req.param 'url', null
  if not url?
    res.status 400
    res.send 'Bad Request. No URL specified.'
    return

  # Check for additional query parameters that might be separated
  filteredQuery = {}
  for key, value of req.query when key isnt 'url'
    filteredQuery[key] = value
  url = "#{url}#{qs.stringify filteredQuery}"

  # Add the user's IP address to make the search a little more context aware
  url += "&userIp=#{req.ip}"

  # Make the request and pass it through
  request.get(url).pipe(res)
  return

# Application listens on port 3000
app.listen 3000