package com.kidslearning.api.repository;

import com.kidslearning.api.model.*;
import java.util.List;
import java.util.Map;

public interface FirebaseRepository {
    ChildProfile getOrCreateProfile(String profileId);
    void saveProfile(ChildProfile profile);

    List<Unit> getAllUnits();
    Unit getUnit(String unitId);
    void saveUnit(Unit unit);
    void deleteUnit(String unitId);

    List<Skill> getAllSkills();
    List<Skill> getSkillsBySubject(Subject subject);
    Skill getSkill(String skillId);
    void saveSkill(Skill skill);
    void deleteSkill(String skillId);

    List<Item> getAllItems();
    Item getItem(String itemId);
    List<Item> getItemsBySkill(String skillId);
    void saveItem(Item item);
    void deleteItem(String itemId);

    ItemProgress getItemProgress(String profileId, String itemId);
    void saveItemProgress(String profileId, ItemProgress progress);
    List<ItemProgress> getAllItemProgress(String profileId);
    void deleteItemProgress(String profileId, String itemId);
    void deleteAllProgress(String profileId);

    int getContentVersion();
    void setContentVersion(int version);
}
