$env.EDITOR = "micro"
$env.BROWSER = "firefox"

$env.PATH = ($env.PATH | append ($nu.home-path | path join ".config/nushell/scripts" ))
