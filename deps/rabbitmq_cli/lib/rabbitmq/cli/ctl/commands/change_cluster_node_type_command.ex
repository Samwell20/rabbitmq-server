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
## The Initial Developer of the Original Code is Pivotal Software, Inc.
## Copyright (c) 2016 Pivotal Software, Inc.  All rights reserved.


defmodule RabbitMQ.CLI.Ctl.Commands.ChangeClusterNodeTypeCommand do
  @behaviour RabbitMQ.CLI.CommandBehaviour


  def merge_defaults(args, opts) do
    {args, opts}
  end

  def validate([], _),  do: {:validation_failure, :not_enough_args}

  # node type
  def validate(["disc"], _), do: :ok
  def validate(["disk"], _), do: :ok
  def validate(["ram"], _),  do: :ok

  def validate([_], _), do: {:validation_failure, {:bad_argument, "The node type must be either disc or ram."}}
  def validate(_, _),   do: {:validation_failure, :too_many_args}

  def run([node_type_arg], %{node: node_name}) do
    case normalize_type(String.to_atom(node_type_arg)) do
      :ram ->
        :rabbit_misc.rpc_call(node_name,
          :rabbit_mnesia, :change_cluster_node_type, [:ram]
        );
      :disc ->
        :rabbit_misc.rpc_call(node_name,
          :rabbit_mnesia, :change_cluster_node_type, [:disc])
    end
  end

  def usage() do
    "change_cluster_node_type <disc|ram>"
  end

  def banner([node_type], %{node: node_name}) do
    "Turning #{node_name} into a #{node_type} node"
  end

  def output({:error, :mnesia_unexpectedly_running}, %{node: node_name}) do
    {:error, RabbitMQ.CLI.Core.ExitCodes.exit_software,
     RabbitMQ.CLI.DefaultOutput.mnesia_running_error(node_name)}
  end
  use RabbitMQ.CLI.DefaultOutput

  defp normalize_type(:ram) do
    :ram
  end
  defp normalize_type(:disc) do
    :disc
  end
  defp normalize_type(:disk) do
    :disc
  end
end
