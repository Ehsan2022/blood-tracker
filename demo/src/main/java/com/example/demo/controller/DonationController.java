package com.example.demo.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.Donation;
import com.example.demo.model.Donor;
import com.example.demo.repository.DonationRepository;
import com.example.demo.repository.DonorRepository;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api/donations")
public class DonationController {

    private final DonationRepository donationRepository;
    private final DonorRepository donorRepository;

    public DonationController(DonationRepository donationRepository, DonorRepository donorRepository) {
        this.donationRepository = donationRepository;
        this.donorRepository = donorRepository;
    }

    @GetMapping
    public ResponseEntity<List<Donation>> getAll() {
        return ResponseEntity.ok(donationRepository.findAll());
    }

    @GetMapping("/donor/{donorId}")
    public ResponseEntity<List<Donation>> getByDonor(@PathVariable Long donorId) {
        return ResponseEntity.ok(donationRepository.findByDonorId(donorId));
    }

    @PostMapping
    public ResponseEntity<Donation> create(@RequestBody Donation donation) {
        Donor donor = donorRepository.findById(donation.getDonor().getId())
                .orElseThrow(() -> new RuntimeException("Donor not found"));
        donation.setDonor(donor);
        return ResponseEntity.ok(donationRepository.save(donation));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Donation> update(@PathVariable Long id, @RequestBody Donation updatedDonation) {
        Donation existing = donationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Donation not found"));
        existing.setDate(updatedDonation.getDate());
        existing.setHospital(updatedDonation.getHospital());
        existing.setUnits(updatedDonation.getUnits());
        existing.setNotes(updatedDonation.getNotes());
        return ResponseEntity.ok(donationRepository.save(existing));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        donationRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}