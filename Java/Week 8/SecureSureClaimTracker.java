import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

public class SecureSureClaimTracker extends JFrame {

    // Instance variables
    private int claimCount = 0;
    private JLabel claimLabel;
    private ArrayList<String> claimLog;

    // Constructor
    public SecureSureClaimTracker() {

        // Initialize ArrayList to simulate stored claims
        claimLog = new ArrayList<>();

        // Set up window
        setTitle("SecureSure Claim Tracker");
        setSize(400, 250);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Create components
        claimLabel = new JLabel("Claims Processed: 0", SwingConstants.CENTER);
        claimLabel.setFont(new Font("Arial", Font.BOLD, 18));

        JButton addButton = new JButton("Add Claim");
        JButton resetButton = new JButton("Reset Counter");

        // Add Claim Button Action
        addButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                addClaim();
            }
        });

        // Reset Button Action
        resetButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                resetClaims();
            }
        });

        // Layout
        setLayout(new BorderLayout());
        add(claimLabel, BorderLayout.CENTER);

        JPanel buttonPanel = new JPanel();
        buttonPanel.add(addButton);
        buttonPanel.add(resetButton);

        add(buttonPanel, BorderLayout.SOUTH);
    }

    // Method to add a claim
    private void addClaim() {
        claimCount++;

        // Simulate storing claim in ArrayList
        claimLog.add("Claim #" + claimCount);

        // Update label
        claimLabel.setText("Claims Processed: " + claimCount);

        // Conditional milestone message
        if (claimCount == 10) {
            JOptionPane.showMessageDialog(this,
                    "Congratulations! You've logged 10 claims!",
                    "Milestone Reached",
                    JOptionPane.INFORMATION_MESSAGE);
        }
    }

    // Method to reset claims
    private void resetClaims() {
        claimCount = 0;
        claimLog.clear();
        claimLabel.setText("Claims Processed: 0");
    }

    // Main Method
    public static void main(String[] args) {

        // Ensure GUI runs on Event Dispatch Thread
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                new SecureSureClaimTracker().setVisible(true);
            }
        });
    }
}