import gleam/bit_string as bs
import gleam/list

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  rna
  |> bs.from_string
  |> do_proteins([])
}

fn do_proteins(
  rna: BitString,
  proteins: List(String),
) -> Result(List(String), Nil) {
  case rna {
    <<"AUG":utf8, rest:binary>> -> do_proteins(rest, ["Methionine", ..proteins])
    <<"UUU":utf8, rest:binary>> ->
      do_proteins(rest, ["Phenylalanine", ..proteins])
    <<"UUC":utf8, rest:binary>> ->
      do_proteins(rest, ["Phenylalanine", ..proteins])
    <<"UUA":utf8, rest:binary>> -> do_proteins(rest, ["Leucine", ..proteins])
    <<"UUG":utf8, rest:binary>> -> do_proteins(rest, ["Leucine", ..proteins])
    <<"UCU":utf8, rest:binary>> -> do_proteins(rest, ["Serine", ..proteins])
    <<"UCC":utf8, rest:binary>> -> do_proteins(rest, ["Serine", ..proteins])
    <<"UCA":utf8, rest:binary>> -> do_proteins(rest, ["Serine", ..proteins])
    <<"UCG":utf8, rest:binary>> -> do_proteins(rest, ["Serine", ..proteins])
    <<"UAU":utf8, rest:binary>> -> do_proteins(rest, ["Tyrosine", ..proteins])
    <<"UAC":utf8, rest:binary>> -> do_proteins(rest, ["Tyrosine", ..proteins])
    <<"UGU":utf8, rest:binary>> -> do_proteins(rest, ["Cysteine", ..proteins])
    <<"UGC":utf8, rest:binary>> -> do_proteins(rest, ["Cysteine", ..proteins])
    <<"UGG":utf8, rest:binary>> -> do_proteins(rest, ["Tryptophan", ..proteins])
    <<"UAA":utf8, _rest:binary>> -> Ok(list.reverse(proteins))
    <<"UAG":utf8, _rest:binary>> -> Ok(list.reverse(proteins))
    <<"UGA":utf8, _rest:binary>> -> Ok(list.reverse(proteins))
    <<"":utf8>> -> Ok(list.reverse(proteins))
    _ -> Error(Nil)
  }
}
