# Flutter Frontend

## Overview 

- This repository contains the frontend code for the application. It's written in Flutter that uses dart as the programming language. It allows to run the application on android and ios.
- Submission By Team TeleHealth Innovators (Kalyan Ram, Ram Sai Koushik)

## How to Run the Application

- Clone the github repo using the `git clone` command.
- Open the folder in `VS Code` and ensure that the flutter and dart extensions are downloaded.
- If all the flutter setup is ready, then the run command in vs code can be used to start the application on an emulator.
- Else, the instructions on running a flutter app can be found in [How to run flutter app](https://docs.flutter.dev/get-started/codelab)

## Features

- Login and Sign Up Pages : 
    
    - Once the app is opened, a login page opens up where different types of users can login to the application.
    - If you are a new user, then a SignUp page open's up where 2 types of signup options are available. A Patient Signup and a Doctor Signup page.
    - The form details asked are different for each type of Signup.

- Multiple Patients in One Account:

  - Once a user is logged in, they can see the different patients that have been added. 
  - They have a option to add new patient with the create chat feature.

- Patient Details Page :

    - This page is seen when A user creates the `create chat` button.
    - Here a few patient details like height, age, medical conditions, health problems, etc are asked.
    - The can then submit the form and they will enter the unified chat interface.

- Unified Chat Interface: 

    - This is the page where the user can chat with the bot. 
    - The user can ask questions based on their health problems and the bot gives responses accordingly.
    - A button on the top right is present which when clicked, assesses the severity of the health problem and suggests doctors from the data based based on the specialization.
    - Once the doctors are suggested, the user has the option to join a temporary chat where they can talk with the doctor in private.

- Temporary Chat and Summaries: 

  - This page allows for communications with the doctor in private.
  - They can make a voice call or a video call based on the needs of the respective users.
  - The video call and audio call buttons can be seen at the top of the page.
  - Once the conversation is done, the doctor can then close the chat and both of them get the summary of the communication that took place.

- Summaries section

    - A patient can view all the summaries that they had so far with different doctors and vice versa by pressing the icon on the top left of the page.

    - The can then click on one of the summaries and see the details of the conversation that took place along with prescription and medication details that the doctor prescribes.

- Patient Details Page

    - The patient can view their Details and have the option to update them too.
    

  
