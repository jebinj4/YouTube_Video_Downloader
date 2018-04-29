# -*- coding: utf-8 -*-
"""
Created on Sun Apr 29 08:52:15 2018

@author: Jebin Jose
"""

import tkinter
from pytube import YouTube

rt=tkinter.Tk()
rt.title("YouTube Video Downloader")
label=tkinter.Label(rt,text="Enter the link")
label.pack()
txtt=tkinter.Entry(rt, width=80)
txtt.pack()





label2=tkinter.Label(rt,text="File desination")
label2.pack()
txt2=tkinter.Entry(rt, width=80)
txt2.pack()




def callback():
    yt = YouTube(txtt.get())
    stream = yt.streams.first()
    destination = txt2.get()
    stream.download(destination)
    donee()
   
   
  
def donee():
    rt1=tkinter.Tk()
    rt1.title("Download Status")
    yt = YouTube(txtt.get())
    label=tkinter.Label(rt1,text=yt.title+"\nHas been successfully downloaded")
    label.pack()



cbutton2=tkinter.Button(rt,text="Download", width=10, command=callback)
cbutton2.pack()

rt.mainloop()

