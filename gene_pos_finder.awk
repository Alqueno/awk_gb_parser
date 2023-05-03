BEGIN {
    FS = "\n";
    RS = "//\n" # Set the record separator to "//" followed by newline
}

# This function extracts the information from the given line
function extract_info(line) {
    split(line, fields, " ")
    return substr(fields[2], 1, length(fields[2]))
}

# This function extracts the product name from the given line
function extract_product_name(line) {
    sub(/^ {21}\/product="/, "", line)
    sub(/"$/, "", line)
    return line
}

{
# Pattern set to nothing so each record is processed.
	accession_number = ""
    product_name = ""
    coordinates = ""
    for (i=1; i<=NF; i++) {
		# scan each field in the record to find the valuable information
        if ($i ~ /^ACCESSION/) {
            accession_number = extract_info($i)
		} else if ($i ~ /^ {5}CDS/) {
			coordinates = extract_info($i)
		} else if ($i ~ /^ {21}\/product="/) {
            product_name = extract_product_name($i)
            if (accession_number != "" && product_name != "" && coordinates != "") {
				print accession_number "\t" coordinates "\t" product_name
				product_name = ""
				coordinates = ""
			}
        } else if ($i ~ /^ORIGIN/) {
			# once origin is reached, just print out the information
			accession_number = ""
        }
    }
}

