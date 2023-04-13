import pdfplumber
data_path = "../../data/pdf/file1.pdf"
with pdfplumber.open(data_path) as pdf:
    first_page = pdf.pages[0]
    text = first_page.extract_text()
    print(text)
    # print(first_page.chars[0])