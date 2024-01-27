1U0022_PUBLIC_COMPONENT_GIT_BASE      ??= "git+https://github.com/ConsolinnoEnergy"
1U0022_PUBLIC_COMPONENT_GIT_BASE_XTRA ??= ""

1U0022_PUBLIC_COMPONENT_GIT_BRANCH     ??= ""
1U0022_PUBLIC_COMPONENT_GIT_BRANCH[type] = "string"

1U0022_PUBLIC_COMPONENT_GIT_SUFFIX     ??= "true"
1U0022_PUBLIC_COMPONENT_GIT_SUFFIX[type] = "boolean"

1U0022_PUBLIC_COMPONENT_GIT_AUTOREV     ??= "false"
1U0022_PUBLIC_COMPONENT_GIT_AUTOREV[type] = "boolean"

SRC_URI[vardepsexclude] += "1U0022_PUBLIC_COMPONENT_GIT_BASE 1U0022_PUBLIC_COMPONENT_GIT_BASE_XTRA"

## disable mirrors; 1u0022 components are private repositories which can
## not be found on mirrors and searching them there would leak internal
## information
PREMIRRORS = ""
MIRRORS = ""

def l1u0022_public_component_uri(d, component, xtra = "", branch = None):
    import urllib, re, os.path

    if component.endswith('.git'):
        bb.error("component ends with .git; use 1U0022_PUBLIC_COMPONENT_GIT_SUFFIX to control this suffix")

    if oe.data.typed_value('1U0022_PUBLIC_COMPONENT_GIT_SUFFIX', d):
        component += '.git'

    git_branch = d.getVar("1U0022_PUBLIC_COMPONENT_GIT_BRANCH", False)
    is_autorev = oe.data.typed_value('1U0022_PUBLIC_COMPONENT_GIT_AUTOREV', d)

    if (branch is None or is_autorev) and git_branch != '':
        branch = '${1U0022_PUBLIC_COMPONENT_GIT_BRANCH}'

    if branch is not None:
        xtra += ";branch=%s" % d.expand(branch)

    base = d.getVar('1U0022_PUBLIC_COMPONENT_GIT_BASE')
    uri = urllib.parse.urlparse(base)
    scheme = uri.scheme.split('+')

    if len(scheme) < 2:
        ## use as-is
        base  = os.path.join('${1U0022_PUBLIC_COMPONENT_GIT_BASE}', component)
    else:
        path  = os.path.join(uri.path, component)
        uri   = urllib.parse.ParseResult(scheme[0], uri.netloc, path, uri.params, uri.query, uri.fragment)
        xtra += ';protocol=%s' % scheme[1]
        base  = uri.geturl()

    return "%s${1U0022_PUBLIC_COMPONENT_GIT_BASE_XTRA}%s" % (base, xtra)
