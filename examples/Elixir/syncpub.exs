defmodule Syncpub do
  @moduledoc """
  Generated by erl2ex (http://github.com/dazuma/erl2ex)
  From Erlang source: (Unknown source file)
  At: 2019-12-20 13:57:34

  """

  defmacrop erlconst_SUBSCRIBERS_EXPECTED() do
    quote do
      2
    end
  end


  def main() do
    {:ok, context} = :erlzmq.context()
    {:ok, publisher} = :erlzmq.socket(context, :pub)
    :ok = :erlzmq.bind(publisher, 'tcp://*:5561')
    {:ok, syncservice} = :erlzmq.socket(context, :rep)
    :ok = :erlzmq.bind(syncservice, 'tcp://*:5562')
    :io.format('Waiting for subscribers.  Please start 2 subscribers.~n')
    sync_subscribers(syncservice, erlconst_SUBSCRIBERS_EXPECTED())
    :io.format('Broadcasting messages~n')
    broadcast(publisher, 1000000)
    :ok = :erlzmq.send(publisher, "END")
    :ok = :erlzmq.close(publisher)
    :ok = :erlzmq.close(syncservice)
    :ok = :erlzmq.term(context)
  end


  def sync_subscribers(_syncservice, 0) do
    :ok
  end

  def sync_subscribers(syncservice, n) when n > 0 do
    {:ok, _} = :erlzmq.recv(syncservice)
    :ok = :erlzmq.send(syncservice, <<>>)
    sync_subscribers(syncservice, n - 1)
  end


  def broadcast(_publisher, 0) do
    :ok
  end

  def broadcast(publisher, n) when n > 0 do
    :ok = :erlzmq.send(publisher, "Rhubarb")
    broadcast(publisher, n - 1)
  end

end

Syncpub.main
