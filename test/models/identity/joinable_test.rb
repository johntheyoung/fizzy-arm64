require "test_helper"

class Identity::JoinableTest < ActiveSupport::TestCase
  test "join" do
    identity = identities(:david)

    user = identity.join(accounts(:initech))
    assert_kind_of User, user
    assert_equal accounts(:initech), user.account
    assert_equal identity.email_address, user.name

    identity = identities(:mike)

    user = identity.join(accounts("37s"), name: "Mike")
    assert_kind_of User, user
    assert_equal accounts("37s"), user.account
    assert_equal "Mike", user.name
  end

  test "member_of?" do
    identity = identities(:david)
    assert identity.member_of?(accounts("37s"))
    assert_not identity.member_of?(accounts(:initech))
  end
end
