defmodule Challenge01Reports.ParseTest do
  use ExUnit.Case
  alias Challenge01Reports.Parser

  describe "parse_file/1" do
    test "parses the file" do
      file_name = "gen_report.csv"

      response = file_name
        |> Challenge01Reports.Parser.parse_file()
        |> Enum.map(& &1)

      expected_response = true

      assert is_list(response) === expected_response
    end
  end
end
