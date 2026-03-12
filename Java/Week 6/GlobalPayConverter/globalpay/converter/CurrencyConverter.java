package globalpay.converter;

import java.text.DecimalFormat;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Scanner;

public class CurrencyConverter {

    // Fixed exchange rates
    private static final double USD_TO_EUR = 0.90;
    private static final double USD_TO_MXN = 17.00;

    public static void main(String[] args) {

        // Load messages file
        ResourceBundle messages = ResourceBundle.getBundle(
                "globalpay.converter.Messages",
                Locale.US
        );

        Scanner scanner = new Scanner(System.in);
        DecimalFormat df = new DecimalFormat("#0.00");

        System.out.println(messages.getString("welcome"));

        try {
            // Get amount
            System.out.println(messages.getString("enterAmount"));
            double amount = Double.parseDouble(scanner.nextLine());

            // Get currency
            System.out.println(messages.getString("enterCurrency"));
            String currency = scanner.nextLine().toUpperCase();

            double convertedAmount;

            switch (currency) {
                case "EUR":
                    convertedAmount = amount * USD_TO_EUR;
                    break;
                case "MXN":
                    convertedAmount = amount * USD_TO_MXN;
                    break;
                default:
                    throw new IllegalArgumentException("Unsupported currency");
            }

            System.out.println(messages.getString("result") + " " + df.format(convertedAmount));

        } catch (NumberFormatException e) {
            System.out.println(messages.getString("errorInvalid"));
        } catch (IllegalArgumentException e) {
            System.out.println(messages.getString("errorCurrency"));
        } finally {
            System.out.println(messages.getString("thankYou"));
            scanner.close();
        }
    }
}
