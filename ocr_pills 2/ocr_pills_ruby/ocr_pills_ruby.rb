require 'ocr_space'

resource = OcrSpace::Resource.new(apikey: ENV["OCR_SPACE_API_KEY"])

result_str = resource.clean_convert file: "/home/nduncan/Documents/ocr_pills/test7.jpg"

result_str = result_str.split.join(" ").upcase

puts result_str

$drug_list = []
File.open("/home/nduncan/Documents/ocr_pills/drugs_processed.txt", "r") do |f|
  f.each_line do |line|
    $drug_list.push(line.upcase.squeeze(" ").strip)
  end
end

def find_drug_name_match(str1)
	for drug_name in $drug_list
		if drug_name == str1
			return drug_name
		end
	end

	return nil
end

def get_drug_name(str1)
	str_split = str1.split()

	for word in str_split
		result = find_drug_name_match(word)
		if result
			return result
		end
	end

	return nil
end

def get_str_from_regex(str1, r1)
	match = r1.match(str1)

	if not match
		return nil
	else
		return match[0]
	end
end

def get_amount_to_take(str1)
	get_str_from_regex(str1, /(((\d)-(\d))|((\d)+)) (TABLET|CAPSULE)(S){0,1}/)
end

def get_freq_to_take(str1)
	get_str_from_regex(str1, /(EVERY (((\d)+ (\w)+)|((\w)+)))|((\w)+ DAILY)|(AT (\w)+)/)
end

def get_delivery_method(str1)
	get_str_from_regex(str1, /(BY MOUTH)|(BY DICK)|(SWALLOW (\w)+)/)
end

parsed_result = {}
parsed_result['Name'] = get_drug_name(result_str)
parsed_result['Delivery'] = get_delivery_method(result_str)
parsed_result['Amount'] = get_amount_to_take(result_str)
parsed_result['Frequency'] = get_freq_to_take(result_str)


puts parsed_result
