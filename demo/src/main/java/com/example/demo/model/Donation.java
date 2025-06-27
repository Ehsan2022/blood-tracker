package com.example.demo.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Donation {
    @Id @GeneratedValue
    private Long id;

    private LocalDate date;
    private String hospital;
    private int units;
    private String notes;

    @ManyToOne
    @JoinColumn(name = "donor_id")
    private Donor donor;
}
