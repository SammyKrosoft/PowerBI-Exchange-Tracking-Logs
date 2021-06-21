# PowerBI-Exchange-Tracking-Logs
This is a PowerBI template to visualize message statistics from Exchange servers, from our great Bernard Chouinard, former Microsoft Engineer, and the best Messaging Architect I have ever known, who designed environments for up to 155,000 mailboxes !

# See the magic

Want to see how it works ? [Check out Bernie's Youtube video about it.](https://www.youtube.com/watch?v=PnJ61q_sB_w)

# How to set it up

## First gather your tracking log files into a common directory

You can copy logs on a directory manually, or use the ```GetTrackingLog.ps1``` script to copy the logs of your servers on a desired centralized location.

## Second update the PowerBI folder location variable

Then update the PowerBI's ```Var_LogFolder``` variable to match the root folder where your tracking logs are located.

To do so, open the PowerBI .pbix file and locate the "Queries > Transform data menu on the "Home" tab
![image](https://user-images.githubusercontent.com/33433229/122836955-41d60c00-d2c1-11eb-88c0-8c28fd029b28.png)

Zooming in :

![image](https://user-images.githubusercontent.com/33433229/122836974-4b5f7400-d2c1-11eb-93f4-1ae6edae83c9.png)

Then click on "Transform data":

![image](https://user-images.githubusercontent.com/33433229/122837011-5f0ada80-d2c1-11eb-8fc6-cfcd24b853ae.png)

The Power Query Editor window will open, look at the left "Queries" pane:

![image](https://user-images.githubusercontent.com/33433229/122837039-6c27c980-d2c1-11eb-8f41-27f39982f516.png)

On that Queries pane, right-click on "Var_LogFolder"

![image](https://user-images.githubusercontent.com/33433229/122837143-97121d80-d2c1-11eb-970b-58fbdd625b3c.png)

You'll see a drop-down menu, choose "Advanced Editor":

![image](https://user-images.githubusercontent.com/33433229/122837188-b01ace80-d2c1-11eb-95cb-b07bec441db2.png)

Zooming in:

![image](https://user-images.githubusercontent.com/33433229/122837207-b7da7300-d2c1-11eb-88a5-759953a431ac.png)

This will open the Advanced Editor, this is where you paste your Tracking Logs root folder:

![image](https://user-images.githubusercontent.com/33433229/122837251-c7f25280-d2c1-11eb-82aa-a908442936e8.png)

Zooming in:

![image](https://user-images.githubusercontent.com/33433229/122837283-d3de1480-d2c1-11eb-9964-ba49b89d8c58.png)

And for example if I put my Tracking log files under C:\temp\TrackingLogs, I just paste this value between the double quotes after the ```Source =``` :

![image](https://user-images.githubusercontent.com/33433229/122837378-f839f100-d2c1-11eb-92fa-59e94aca3907.png)


# Download the PowerBI Template

[Download the PowerBI Template here](https://github.com/SammyKrosoft/PowerBI-Exchange-Tracking-Logs/raw/main/Trackinglog-Final-Lab2.zip)

# Download the PowerShell script that copies the tracking logs to a central location

[Right-Click "Save Link As" to download the GetTrackingLog.ps1 script](https://raw.githubusercontent.com/SammyKrosoft/PowerBI-Exchange-Tracking-Logs/main/GetTrackingLog.ps1)
