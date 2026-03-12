// Name: Dominic Bumpus
// Course: IS--5103-2O1
// Program: Calculate and display weekly sales performance data

public class WeeklySalesPerformance {

    public static void main(String[] args) {

        // Store name
        String storeName = "Trendy Threads Boutique";

        // Array to hold daily sales totals
        double[] dailySales = {
                1200.50, 985.25, 1105.75, 1340.00, 1015.30,
                970.45, 1500.00, 880.50, 1120.75, 995.00
        };

        // Total weekly sales
        double totalSales = 0.0;

        // Calculate total sales
        for (double sale : dailySales) {
            totalSales += sale;
        }

        // Calculate average sales
        double averageSales = totalSales / dailySales.length;

        // Prints store name
        System.out.printf("Store: %s%n%n", storeName);

        // Prints daily sales from array
        System.out.print("Daily Sales: ");
        for (int i = 0; i < dailySales.length; i++) {
            System.out.printf("%.2f", dailySales[i]);
            if (i < dailySales.length - 1) {
                System.out.print(", ");
            }
        }

        //Prints average sales
        System.out.printf("%n%nAverage Daily Sales: $%.2f%n", averageSales);
    }
}
