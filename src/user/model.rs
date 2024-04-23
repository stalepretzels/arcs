use std::error::Error;
use rustrict::{Censor, Type};

#[derive(Clone)]
pub struct User {
    pub name: String,
    pub id: i32,
    pub glass: GlassModeration
}

impl User {
    pub fn new(name: String, id: i32) -> Self {
        Self {
            name,
            id,
            glass: GlassModeration::default()
        }
    }
}

#[derive(Clone, Default)]
pub struct GlassModeration {
    reports: i32,
    warnings: i32,
    pub is_muted: bool
}

impl GlassModeration {
    /// Runs the given text through a censoring filter.
    /// This will add reports if it finds Type::OFFENSIVE, returning an error.
    /// If it finds no Type::OFFENSIVE, but Type::EVASIVE, it will instead warn the user.
    /// If the user is muted, it returns an error.
    pub fn process(&mut self, input: &str) -> Result<String, Box<dyn Error>> {
        if self.is_muted { return Err("User is muted".into()); }

        let (censored, analysis) = Censor::from_str(input)
            .with_censor_threshold(Type::SEVERE)
            .with_censor_first_character_threshold(Type::OFFENSIVE & Type::SEVERE)
            .with_ignore_false_positives(false)
            .with_ignore_self_censoring(false)
            .with_censor_replacement('*')
            .censor_and_analyze();

        if analysis.is(Type::OFFENSIVE & Type::SEVERE) {
            self.warn();
            Err("Message is inappropriate".into())
        } else {
            if analysis.is(Type::EVASIVE) {
                self.warn();
            }
            Ok(censored)
        }
    }

    /// Warns the user, adding a report if there are 5 warnings.
    pub fn warn(&mut self) {
        self.warnings += 1;
        if self.warnings >= 5 {
            self.warnings = 0;
            self.reports += 1;
        }
    }

    /// Reports the user, muting them if there are 10 warnings.
    pub fn report(&mut self) {
        self.reports += 1;
        if self.reports >= 10 {
            self.is_muted = true;
        }
    }

    /// Mutes the user.
    pub fn mute(&mut self) { self.is_muted = true; }

    /// Unmutes the user.
    pub fn unmute(&mut self) { self.is_muted = false; }
}