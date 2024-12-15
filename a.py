# -*- coding: utf-8 -*-
"""
Created on Sun Apr 29 08:52:15 2018

@author: Jebin Jose (Updated with improvements)
"""

import tkinter
from tkinter import filedialog, messagebox
from pytube import YouTube

# Main application window
rt = tkinter.Tk()
rt.title("YouTube Video Downloader")

# URL Input Label and Entry
label = tkinter.Label(rt, text="Enter the YouTube Video URL:")
label.pack(pady=5)
txtt = tkinter.Entry(rt, width=80, bg="white", fg="black")  # Set white background and black text
txtt.pack(pady=5)

# Destination Path Label and Entry
label2 = tkinter.Label(rt, text="Select Destination Folder:")
label2.pack(pady=5)
txt2 = tkinter.Entry(rt, width=80, bg="white", fg="black")  # Set white background and black text
txt2.pack(pady=5)

# Function to select the destination folder
def select_destination():
    folder = filedialog.askdirectory()
    if folder:
        txt2.delete(0, tkinter.END)
        txt2.insert(0, folder)

# Function to handle video download
def download_video():
    try:
        # Print the URL for debugging
        print(f"Processing URL: {txtt.get()}")
        
        # Get the YouTube video object
        yt = YouTube(txtt.get())
        
        # Select the highest resolution stream
        stream = yt.streams.get_highest_resolution()
        
        # Get the destination path
        destination = txt2.get()
        if not destination:
            raise ValueError("Please select a destination folder.")
        
        # Download the video
        stream.download(destination)
        
        # Show success message
        messagebox.showinfo("Download Complete", f"'{yt.title}' has been successfully downloaded.")
    except Exception as e:
        # Show error message
        messagebox.showerror("Error", f"An error occurred: {str(e)}")

# Button to select folder
destination_button = tkinter.Button(rt, text="Browse", command=select_destination)
destination_button.pack(pady=5)

# Button to start download
download_button = tkinter.Button(rt, text="Download", width=10, command=download_video)
download_button.pack(pady=10)

# Run the Tkinter main loop
rt.mainloop()