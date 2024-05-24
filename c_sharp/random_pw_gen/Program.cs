using System;
using System.Text;

public class RandomPassGenerator
{
    public static void Main(string[] args)
    {
        string newRandomPass = Password(GetLength());
        Console.WriteLine($"Your new ranadom password is: {newRandomPass}");
    }

    public static int GetLength() 
    {
        Console.WriteLine("Welcome to the random password generator!");
        Console.Write("Please enter your desired password length (no greater than 30): ");
        string input = Console.ReadLine()!; 

        int passLength;
        bool isInt = Int32.TryParse(input, out passLength);
        while (!isInt || passLength > 30) {
            Console.Write("The given length is invalid. Try again: ");
            input = Console.ReadLine()!;
            isInt = Int32.TryParse(input, out passLength);
        }
        
        return passLength;
    }

    public static string Password(int length) 
    {
        string alphabet = "abcdefghijklmnopqrstuvwxyz";
        string num = "0123456789";
        string specialChar = "!$^&*?+";
        int insert;

        StringBuilder sb = new StringBuilder("", length);
        Random rand = new Random();

        for (int i = 0; i < length; i++) {
            insert = new Random().Next(0, 3);
            switch (insert) {
                case 0:
                    if (i % 3 == 0) {
                        sb.Append(char.ToUpper(alphabet[rand.Next(0, alphabet.Length)]));
                    }
                    else {
                        sb.Append(alphabet[rand.Next(0, alphabet.Length)]);
                    }
                    break;
                case 1:
                    sb.Append(num[rand.Next(0, num.Length)]);
                    break;
                case 2:
                    sb.Append(specialChar[rand.Next(0, specialChar.Length)]);
                    break;
            }
        }

        return sb.ToString();
    }

}