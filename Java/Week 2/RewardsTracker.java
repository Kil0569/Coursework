package creditcardpro;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class RewardsTracker {

    public static void main(String[] args) {
        // Declare Arrays
        @SuppressWarnings("unused")
        String[] categories = {"GROCERY", "DINING", "TRAVEL", "GAS", "OTHER"};
        double[] transactions = {110.65, 95.90, 240.97, 42.30, 127.01};

        // Calculate total spending
        double totalSpending = 0.0;
        for (double amount : transactions) {
            totalSpending += amount;
        }
        // Rounding Results
        totalSpending = Math.round(totalSpending * 100.0) / 100.0;

        // Rewards tier
        String tier;
        int tierMultiplier;

        if (totalSpending >= 500) {
            tier = "Platinum";
            tierMultiplier = 3;
        } else if (totalSpending >= 250) {
            tier = "Gold";
            tierMultiplier = 2;
        } else {
            tier = "Silver";
            tierMultiplier = 1;
        }

        // Base reward points
        int basePoints = (int) totalSpending;
        int tierPoints = basePoints * tierMultiplier;

        // Promo codes
        String promoCode = new String("BONUS10");
        int bonusPoints = 0;

        switch (promoCode) {
            case "BONUS10":
                bonusPoints = (int) (tierPoints * 0.10);
                break;
            case "TRAVEL5":
                bonusPoints = (int) (tierPoints * 0.05);
                break;
            default:
                bonusPoints = 0;
        }

        // String equality
        System.out.println("Equality demo:");
        System.out.println(promoCode == "BONUS10");         
        System.out.println(promoCode.equals("BONUS10"));    

        // == compares memory references
        // .equals() compares string content

        System.out.println();

        // Progress message
        int counter = 0;
        while (counter < 3) {
            System.out.println("Calculating rewards...");
            counter++;
        }

        // Date
        LocalDate today = LocalDate.now();
        LocalDate nextBilling = today.plusDays(30);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        // Final formatted output
        System.out.println("\n=== CreditCardPro Monthly Summary ===");
        System.out.printf("Date: %s%n", today.format(formatter));
        System.out.printf("Next Billing: %s%n", nextBilling.format(formatter));
        System.out.println("-----------------------------------");
        System.out.printf("Total Spending: $%.2f%n", totalSpending);
        System.out.printf("Tier: %s (x%d points)%n", tier, tierMultiplier);
        System.out.printf("Base Points: %d%n", tierPoints);
        System.out.printf("Bonus Points: %d%n", bonusPoints);
        System.out.printf("Total Points Earned: %d%n",
                tierPoints + bonusPoints);
        System.out.printf("Promo Code Used: %s%n", promoCode);
        System.out.println("Message: Great work! Keep building your rewards.");
    }
}
