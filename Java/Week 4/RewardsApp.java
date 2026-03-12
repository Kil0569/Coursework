import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.function.Consumer;

public class RewardsApp {
    // Interface
    interface Rewardable {
        int calculatePoints(double purchaseAmount);
    }

    // Enum
    enum CustomerType {
        REGULAR,
        PREMIUM
    }

    // Sealed Class
    sealed abstract class Customer
            implements Rewardable
            permits RegularCustomer, PremiumCustomer {

        protected String name;
        protected CustomerType type;

        public Customer(String name, CustomerType type) {
            this.name = name;
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public CustomerType getType() {
            return type;
        }
    }

    // Regular Customer
    final class RegularCustomer extends Customer {

        public RegularCustomer(String name) {
            super(name, CustomerType.REGULAR);
        }

        @Override
        public int calculatePoints(double purchaseAmount) {
            return (int) purchaseAmount;
        }
    }

    // Premium Customer
    final class PremiumCustomer extends Customer {

        public PremiumCustomer(String name) {
            super(name, CustomerType.PREMIUM);
        }

        @Override
        public int calculatePoints(double purchaseAmount) {
            return (int) (purchaseAmount * 1.5);
        }
    }

    // Main
    public static void main(String[] args) {

        RewardsApp app = new RewardsApp();

        //Create list of customers
        List<Customer> customers = new ArrayList<>();
        customers.add(app.new RegularCustomer("Max Caulfield"));
        customers.add(app.new PremiumCustomer("Alex Chen"));

        //Purchase amount
        double purchaseAmount = 200.00;

        //Bonus multiplier (10%)
        Function<Integer, Double> bonusMultiplier =
                points -> points * 1.10;

        //Functional interface
        Consumer<String> printLine = System.out::println;

        //Display rewards
        for (Customer customer : customers) {

            int basePoints = customer.calculatePoints(purchaseAmount);
            double finalPoints = bonusMultiplier.apply(basePoints);

            printLine.accept("\n------------------------------");
            System.out.printf("Customer: %s%n", customer.getName());
            System.out.printf("Type: %s%n", customer.getType());
            System.out.printf("Purchase: $%.2f%n", purchaseAmount);

            System.out.printf("Base Points: %d%n", basePoints);
            System.out.printf("Bonus Applied: 10%%%n");

            System.out.printf("Final Points: %.1f%n", finalPoints);
        }

        printLine.accept("\n------------------------------");
        printLine.accept("Rewards processing complete.");
    }
}
