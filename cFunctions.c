#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void display(char* stringsArray[], int size){
	//loop through the array and display messages
    for (int i = 0; i < size; i++){
      printf( "Message[%d]: %s\n", i, stringsArray[i]);
    }
}

void readHelper(char* stringsArray[], int size) {
    static int index = 0; // Static variable to keep track of the index

    char user_input[1000];

    printf("Enter new message: ");
    fgets(user_input, sizeof(user_input), stdin);
    // remove newline at the end
    user_input[strcspn(user_input, "\n")] = '\0';

    if (isupper(user_input[0])&& ((user_input[strlen(user_input) - 1] == '.') || (user_input[strlen(user_input) - 1] == '?') ||
				 (user_input[strlen(user_input) - 1] == '!'))) {
         // Replace the message in the array
         strcpy(stringsArray[index], user_input);
         index = (index + 1) % size;
    } else {
         printf("Invalid message, keeping the current message.\n");
      }
}

char* return_message(char* stringsArray[]){
	//returns the message at a given position
    int arr_char = 0;
    printf("Enter string location: ");
    scanf("%d", &arr_char);
    //printf("%s\n", stringsArray[arr_char]);
    return stringsArray[arr_char];
}
void displayEE(){
	//displays easter egg "Have a great summer" in style
  printf("  _   _   _   _   _   _   _   _   _   _   _   _   _  \n");
  printf(" / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ \n");
 printf("( H | A | V | E |   | A |   | G | R | E | A | T |  )\n");
 printf(" \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \n");
 printf("  _   _   _   _   _   _   _   _   _   _   _   _   _  \n");
 printf(" / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ / \\ \n");
 printf("(  |  |  |  | S | U  | M  | M  | E  | R  |   |   |   )\n");
 printf(" \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \\_/ \n");

}

//decrypt the message using a shiftValue value
void decryptMessage(const char *original, char *decrypted, int shiftValue) {
    strcpy(decrypted, original);
    for (int i = 0; i < strlen(decrypted); i++) {
        if (isalpha(decrypted[i])) {
            char base = isupper(decrypted[i]) ? 'A' : 'a';
            decrypted[i] = (decrypted[i] - base - shiftValue + 26) % 26 + base;
        }
    }
}
void decrypt_message(char* myStr){
     // Frequency analysis
    int frequency[26] = {0};
    for (int i = 0; i < strlen(myStr); i++) {
        if (isalpha(myStr[i])) {
            char c = tolower(myStr[i]);
            frequency[c - 'a']++;
        }
    }
    // Find the 5 most common letters
    int maxIndexes[5] = {0};
    for (int j = 0; j < 5; j++) {
        int maxIndex = 0;
        for (int i = 1; i < 26; i++) {
            if (frequency[i] > frequency[maxIndex]) {
                maxIndex = i;
            }
        }
        frequency[maxIndex] = 0;
        maxIndexes[j] = maxIndex;
    }
    // Decrypt the message using the 5 most common letters
    for (int i = 0; i < 5; i++) {
        char decrypted[1000];
        strcpy(decrypted, myStr);
        decryptMessage(myStr, decrypted, maxIndexes[i] - ('e' - 'a'));
        printf("Decryption %d: %s \n", i + 1, decrypted);
    }

}
