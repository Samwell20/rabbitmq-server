## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2017 Pivotal Software, Inc.  All rights reserved.

defmodule DiscoverPeersCommandTest do
  use ExUnit.Case, async: false
  import TestHelper

  @command RabbitMQ.CLI.Diagnostics.Commands.DiscoverPeersCommand
  setup_all do
    RabbitMQ.CLI.Core.Distribution.start()
    :ok
  end

  setup context do
    {:ok, opts: %{node: get_rabbit_hostname(), timeout: context[:test_timeout]}}
  end

  test "validate: providing no arguments passes validation", context do
    assert @command.validate([], context[:opts]) == :ok
  end

  test "validate: providing any arguments fails validation", context do
    assert @command.validate(["a"], context[:opts]) ==
      {:validation_failure, :too_many_args}
  end
  
  @tag test_timeout: 15000
  test "run: returns a list of nodes when the backend isn't configured", context do
    assert match?({:ok, {[], _}}, @command.run([], context[:opts]))
  end
end
