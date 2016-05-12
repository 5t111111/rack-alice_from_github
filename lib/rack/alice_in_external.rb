# Stubbing authentication via Sorcery external
#
# Assume you have built the controller following to the below post:
# https://github.com/NoamB/sorcery/wiki/External
#
# Requires a user has an associtation with authentications(uid: 42)

require 'rack/alice_in_external/version'
require 'rack/alice_in_external/webmock_stubs'
require 'rack/alice_in_external/github_mock'
