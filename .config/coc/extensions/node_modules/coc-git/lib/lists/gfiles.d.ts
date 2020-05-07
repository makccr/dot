import { BasicList, ListAction, ListContext, ListItem, Neovim } from 'coc.nvim';
import Manager from '../manager';
export default class Gfiles extends BasicList {
    private manager;
    readonly name = "gfiles";
    readonly description = "view files on different branches (or commits, or tags)";
    readonly detail = "Pass git sha as first command argument, when empty, HEAD is used.\nExample: :CocList gfiles 7b5c5cb";
    readonly defaultAction = "edit";
    actions: ListAction[];
    constructor(nvim: Neovim, manager: Manager);
    loadItems(context: ListContext): Promise<ListItem[]>;
}
