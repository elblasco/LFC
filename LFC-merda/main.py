from pypdf import PdfReader
import matplotlib.pyplot as plt

def mean(marks):
   return sum(marks)/len(marks)

def standard_deviation(marks):
   average = mean(marks)
   sum = 0
   for mark in marks:
      sum = sum + (mark - average)**2
   return (sum/len(marks))**0.5

if __name__ == '__main__':

   # Open the pdf file and extraction of the text
   reader = PdfReader('voti.pdf')
   page = reader.pages[0]
   text = page.extract_text()
   raw_list = list()

   # For looping through the text and extraction of the marks as strings
   for grade in text.splitlines():
      raw_list.append(grade[-2:])

   # Conversion of the marks from string to int
   marks_list=[eval(i) for i in raw_list]
   
   # Computing the mean and the standard deviation of the marks
   average_mark = mean(marks_list)
   sd_mark = standard_deviation(marks_list)

   # Printing the results
   print('The average mark is: ',average_mark)
   print('The standard deviation of the marks is: ',sd_mark)

   # Plotting the histogram
   plt.xlabel('Marks')
   plt.ylabel('Person')
   plt.hist(marks_list, edgecolor='black', range=(0,30), bins=range(0,30), histtype='bar')
   plt.show()