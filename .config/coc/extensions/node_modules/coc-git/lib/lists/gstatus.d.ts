import { BasicList, ListAction, ListContext, ListItem, Neovim } from 'coc.nvim';
import Manager from '../manager';
export default class GStatus extends BasicList {
    private manager;
    readonly name = "gstatus";
    readonly description = "Git status of current project";
    readonly defaultAction = "open";
    actions: ListAction[];
    constructor(nvim: Neovim, manager: Manager);
    private reset;
    private checkout;
    loadItems(context: ListContext): Promise<ListItem[]>;
}
