package ordersystem;

public class CoffeeShopOrder {

    public static void main(String[] args) {

        // Quantities
        int coffees = 2;
        int teas = 1;
        int pastries = 3;

        // Prices
        double coffeePrice = 3.50;
        double teaPrice = 2.75;
        double pastryPrice = 2.25;

        // Tax rate
        double taxRate = 0.07;

        //Calculations
        double subtotal = (coffees * coffeePrice) + (teas * teaPrice) + (pastries * pastryPrice);

        double tax = subtotal * taxRate;
        double total = subtotal + tax;

        // Output
        System.out.println("Coffees: " + coffees);
        System.out.println("Teas: " + teas);
        System.out.println("Pastries: " + pastries);
        System.out.println();

        System.out.printf("Subtotal: $%.2f%n", subtotal);
        System.out.printf("Tax: $%.2f%n", tax);
        System.out.printf("Total: $%.2f%n", total);
        System.out.println();

        // Comparison
        if (total > 15) {
            System.out.println("You qualify for a free drink!");
        } else {
            System.out.println("Add more items to qualify for a free drink!");
        }
    }
}
