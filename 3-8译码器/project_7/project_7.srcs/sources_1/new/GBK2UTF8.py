import codecs
import os
def ReadFile(filePath,encoding=""):
    with codecs.open(filePath,"r",encoding) as f:
        return f.read()

def WriteFile(filePath,text,encoding=""):
    with codecs.open(filePath,"w",encoding) as f:
        #f.write(u.encode(encoding,errors="ignore"))
        f.write(text)

def UTF8_2_GBK(src,dst):
    content = ReadFile(src,encoding="utf-8")
    WriteFile(dst,content,encoding="gb18030")

def GBK_2_UTF8(src,dst):
    content = ReadFile(src,encoding="gb18030")
    WriteFile(dst,content,encoding="utf-8")

def ls_files(path, file_type=[".txt", ".cpp", ".h"]):  # file_type = [".txt", ".cpp", ".h"]
    file_list = []
    for root,dirs,files in os.walk(path):
        for file in files:
            full_path = os.path.join(root,file)
#             print(full_path)
            ext = os.path.splitext(full_path)[1]
#             print(ext)
            if ext in file_type:
                file_list.append(full_path)
    return file_list

if __name__ == "__main__":
    file_type=[".v"]
    for file in ls_files('./', file_type=file_type):
        print(file)
        #UTF8_2_GBK(file, file)
        GBK_2_UTF8(file, file)    
