package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.example.demo.repository.DonationRepository;


@RestController
@RequestMapping("/api/donations")
@CrossOrigin
public class DonationController {

    @Autowired private DonationRepository repo;

    @GetMapping("/donor/{donorId}")
    public List<Donation> getByDonor(@PathVariable Long donorId) {
        return repo.findByDonorId(donorId);
    }

    @PostMapping
    public Donation create(@RequestBody Donation donation) {
        return repo.save(donation);
    }

    @PutMapping("/{id}")
    public Donation update(@PathVariable Long id, @RequestBody Donation donation) {
        donation.setId(id);
        return repo.save(donation);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repo.deleteById(id);
    }
}
