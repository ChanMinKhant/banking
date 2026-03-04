package com.bank.util;

import java.sql.ResultSet;

public class Helper {
    // Simple helper to close resources (optional)
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try { res.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }

    // Print ResultSet for debugging
    public static void printResultSet(ResultSet rs) {
        try {
            int cols = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                for (int i = 1; i <= cols; i++) {
                    System.out.print(rs.getMetaData().getColumnName(i) + "=" + rs.getObject(i) + " | ");
                }
                System.out.println();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}