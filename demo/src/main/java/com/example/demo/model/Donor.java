package com.example.demo.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Donor {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;               // Auto-generated
    private String name;          // Required (non-null)
    private int age;              // Required (primitive, cannot be null)
    private String gender;        // Required
    private String bloodGroup;    // Required
    private String phone;         // Required
    private String city;         // Required
    private LocalDate lastDonation; // Nullable
}
