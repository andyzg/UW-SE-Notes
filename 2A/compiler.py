import sys, os, re

LATEX_REGEX = re.compile("^.*\.tex$")

def build_file(header, body, debug=False):
    file_content = []
    file_content.append(header)
    file_content.append("\\begin{document}")
    if not debug:
        file_content.append("\\maketitle")
        file_content.append("\\tableofcontents")
    file_content.append(body)
    file_content.append("\\end{document}")
    return "\n".join(file_content)

def generate_body(course):
    classes = os.listdir(course)
    body = []
    for filename in classes:
        if not LATEX_REGEX.match(filename):
            continue
        path = "{course_name}/{file_name}".format(course_name=course, file_name=filename)
        with open(path, "r") as text:
            body.append(text.read())

    return "\n".join(body)

def generate_partial_body(course, class_num):
    classes = os.listdir(course)
    file_name = "{class_num}.tex".format(class_num=class_num)
    if file_name in classes:
        path = "{course_name}/{file_name}".format(course_name=course, file_name=file_name)
        with open(path, "r") as body:
            return body.read()
    else:
        sys.exit(1)

def generate_header(course):
    string = []
    with open("./template/header.tex", "r") as header:
        string.append(header.read())
    string.append("\\title{{{course_name}}}".format(course_name=course))
    string.append("\\author{{Andy Zhang}}")
    string.append("\\date{{Fall 2014}}")
    return "\n".join(string)

def compile_full(course):
    header = generate_header(course)
    body = generate_body(course)
    output = build_file(header, body)
    print output

def compile_partial(course, class_num):
    header = generate_header(course)
    body = generate_partial_body(course, class_num)
    output = build_file(header, body, True)
    print output

if __name__ == "__main__":
    length = len(sys.argv)
    if length == 2:
        compile_full(sys.argv[1])
    elif length == 3:
        compile_partial(sys.argv[1], sys.argv[2])
    else:
        exit(1)
